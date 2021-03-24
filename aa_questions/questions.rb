require_relative "questions_database"
require_relative "question_follows"

class Question 
    attr_accessor :id, :title, :body, :user_id

    def self.all
        data = QuestionsDBConnection.instance.execute('SELECT * FROM questions')
        data.map {|datum| Question.new(datum)}
    end

    def self.find_by_id(id)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, id)
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

    def self.find_by_author_id(user_id)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
            SELECT
                *
            FROM
                questions
            WHERE
                user_id = ?
        SQL
    end

    def author
        User.find_by_id(user_id)
    end

    def replies
        Reply.find_by_question_id(id)
    end

    def followers
        QuestionFollow.followers_for_question_id(id)
    end
end