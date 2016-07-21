module WizardHelper
  number_suffixes = %w(one two three four five six seven eight nine ten)
  STEP_NAMES = number_suffixes.map { |suffix| 'step_' + suffix }

  def step_id_for step_number
    STEP_NAMES[step_number - 1]
  end
  alias_method :step_file_name_for, :step_id_for

  def wizard_id
    controller_name + '_wizard'
  end
end