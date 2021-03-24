require_relative 'tables'

class QuestionLike
    attr_accessor :id, :user_id, :question_id

    def self.all
        data = QuestionsDBConnection.instance.execute('SELECT * FROM question_likes')
        data.map {|datum| QuestionLike.new(datum)}
    end

    def self.find_by_id(id)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_likes
            WHERE
                id = ?
        SQL
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

    def self.likers_for_question_id(question_id)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
            SELECT
                users.*
            FROM
                users
            JOIN
                question_likes
            ON
                users.id = question_likes.user_id
            WHERE
                question_likes.question_id = ? 
        SQL
    end

    def self.num_likes_for_question_id(question_id)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
            SELECT
                COUNT(*) AS likes
            FROM
                questions
            JOIN
                question_likes
            ON
                questions.id = question_likes.question_id
            WHERE
                question.id = ? 
        SQL
    end

    def self.liked_questions_for_user_id(user_id)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
            SELECT
                questions.*
            FROM
                questions
            JOIN
                question_likes
            ON
                questions.id = question_likes.question_id
            WHERE
                question_likes.user_id = ? 
        SQL
    end

    def self.most_liked_questions(n)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, limit:n)
            SELECT
                questions.*
            FROM
                questions
            JOIN
                question_likes
            ON
                questions.id = question_likes.question_id
            GROUP BY
                questions.id
            ORDER BY
                COUNT(*) DESC
            LIMIT 
                n
        SQL
    end
end