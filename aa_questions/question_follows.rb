require_relative 'tables'

class QuestionFollow 
    attr_accessor :id, :user_id, :question_id

    def self.all
        data = QuestionsDBConnection.instance.execute('SELECT * FROM question_follows')
        data.map {|datum| QuestionFollow.new(datum)}
    end

    def self.find_by_id(id)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_follows
            WHERE
                id = ?
        SQL
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

    def self.followers_for_question_id(question_id)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                users
            JOIN
                question_follows
            ON
                users.id = question_follows.user_id
            WHERE
                question_id = ?
        SQL
    end

    def self.followed_questions_for_user_id(user_id)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
            SELECT
                questions.*
            FROM
                questions
            JOIN
                question_follows
            ON
                questions.id = question_follows.question_id
            WHERE
                question_follows.user_id = ?
        SQL
    end
end