class Student < ApplicationRecord
  belongs_to :class_section
  belongs_to :school_branch
  has_one :level, through: :class_section
  has_one :section, through: :class_section
  has_many :student_fees
  accepts_nested_attributes_for :student_fees, reject_if: :reject_posts


  def reject_posts(attributes)
    attributes['paid_fee'].blank?

  end
  enum gender: %i[Son Daughter]
  enum student_type: [:Normal, :Orphon, :Deserving, :FeeFree]

  def pay_fee_now(pay_date = nil)
    paid_date = pay_date.nil? ? Date.today : pay_date.to_date
    st_fee = student_fees.new(paid_date: paid_date, paid_fee: self.monthly_fee, fee_type: "Fee")
    st_fee.save!
  end
end
