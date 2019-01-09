class PauseSelectedTask
  include Interactor::Organizer

  organize PauseTask, CreateComment
end