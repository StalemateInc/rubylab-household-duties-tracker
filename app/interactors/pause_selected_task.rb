class PauseSelectedTask
  include Interactor::Organizer

  organize PauseTask, CreatePauseComment
end