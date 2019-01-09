class PerformTextSearch
  include Interactor::Organizer

  organize ConstructSearchQuery, PerformSearch
end