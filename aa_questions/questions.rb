require_relative "questions_database"

class Question 
    attr_accessor :id, :title, :body, :user_id

    def self.all
        data = QuestionsDBConnection.instance.execute('SELECT * FROM questions')
        data.map {|datum| Question.new(datum)}
    end

    def self.find_by_id(id)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, @id)
            SELECT
                *
            FROM
                questions
            WHERE
                id = ?
        SQL
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end
end