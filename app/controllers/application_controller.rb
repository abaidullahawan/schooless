class ApplicationController < ActionController::Base
  before_action :active_branch, :school_branches
  before_action :set_paper_trail_whodunnit
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    students_path
  end

  def active_branch
    return unless current_user

    @school_branch = SchoolBranch.find_by(school_id: current_user.school_id, active: true) if current_user.present?
  end

  def school_branches
    return unless current_user

    @school_branches = SchoolBranch.where(school_id: current_user.school_id)
  end
end
