require_relative 'tables'

class User
    attr_accessor :id, :fname, :lname

    def self.all
        data = QuestionsDBConnection.instance.execute('SELECT * FROM users')
        data.map {|datum| User.new(datum)}
    end

    def self.find_by_id(id)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                users
            WHERE
                id = ?
        SQL
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def self.find_by_name(fname, lname)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
            SELECT
                *
            FROM
                users
            WHERE
                fname = ? AND lname = ?
        SQL
    end

    def authored_questions
        Question.find_by_author_id(id)
    end

    def authored_replies
        Reply.find_by_user_id(id)
    end

    def followed_questions
        QuestionFollow.followed_questions_for_user_id(id)
    end

    def liked_questions
        QuestionLike.liked_questions_for_user_id(id)
    end

    def average_karma
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, user_id: self.id)
            SELECT
                CAST(COUNT(question_likes.id) AS FLOAT) / COUNT(DISTINCT(questions.id)) AS average_likes
            FROM
                questions
            LEFT OUTER JOIN
                question_likes
            ON
                questions.id = question_likes.question_id
            JOIN
                users
            ON
                users.id = question_likes.user_id
            WHERE
                questions.user_id = users.id
        SQL
    end
end
