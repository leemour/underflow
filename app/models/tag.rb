class Tag < ActiveRecord::Base
  default_scope { order('name ASC') }

  has_and_belongs_to_many :questions

  validates :name, presence: true, uniqueness: true, length: {in: 1..30}
  validates :excerpt, length: {in: 15..500}, allow_blank: true
  validates :description, length: {in: 30..6000}, allow_blank: true

  def self.name_list
    pluck(:name)
  end

  # self-implemented counter_cache for has_and_belongs_to_many
  def self.reset_questions_count
    Tag.find_each do |t|
      t.update(questions_count: t.questions.count)
    end
  end
end
