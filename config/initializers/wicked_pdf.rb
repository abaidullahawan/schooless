module WickedPdfHelper
  if Rails.env.production?
    WickedPdf.config = {
      :exe_path => '/app/vendor/bundle/ruby/2.6.0/bin/wkhtmltopdf'
    }
  else
    WickedPdf.config = {
      :exe_path => '/home/abaid/.rbenv/shims/wkhtmltopdf'
    }
  end
end
