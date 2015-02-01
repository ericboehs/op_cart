class UnchangeableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !record.new_record? && value.present?
      if record.changes.include?(attribute) && record.changes[attribute].any?
        record.errors[attribute] << "cannot be changed once assigned"
      end
    end
  end
end
