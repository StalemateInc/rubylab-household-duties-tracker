class BaseInteractor
  include Interactor

  def fail_with_message(action, subject)
    context.fail!(message: "Failed #{action}, subject: #{subject.class.name.downcase} №#{subject.id}!")
  end

end