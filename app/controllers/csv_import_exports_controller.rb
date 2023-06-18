class CsvImportExportsController < ApplicationController
  require 'csv'
  def index
  end

  def export_csv
    modelTable = process_params[:table_name].constantize
    table_data = modelTable.all.order(id: :asc)

    attributes = modelTable.attribute_names
    csv_data = CSV.generate(headers: true) do |csv|
      csv << attributes

      table_data.each do |row|
        csv.add_row row.attributes.values
      end
    end

    send_data csv_data, filename: "#{process_params[:table_name]}.csv"
  end

  def csv_import_export
  end

  def import_csv
    csv_file = process_params.fetch(:file)
    modelTable = process_params[:table_name].constantize
    CSV.foreach(csv_file.path, headers: true, encoding: 'ISO-8859-1') do |row|
      ActiveRecord::Base.transaction do
        modelRecord = modelTable.new(row.to_h)
        rid = modelTable.ids.sort.last + 1
        modelRecord.id = rid
        if modelTable == User
          modelRecord.password = 'devbox@123'
        end
        modelRecord.save!
      rescue => error
        raise ActiveRecord::Rollback, error.message
      end
    end
    redirect_to csv_import_export_path, flash: {
      notice: "CSV #{process_params[:table_name]} imported successfully."
    }
    rescue => error
      redirect_to csv_import_export_path, alert: "Error occurred, #{error.message}"
  end

  def process_params
    params.require(:process).permit(:table_name, :file)
  end
end
