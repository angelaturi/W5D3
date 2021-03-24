require_relative "questions_database"

class Reply 
    attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

    def self.all
        data = QuestionsDBConnection.instance.execute('SELECT * FROM replies')
        data.map {|datum| Reply.new(datum)}
    end

    def self.find_by_id(id)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                id = ?
        SQL
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
        @user_id = options['user_id']
        @body = options['body']
    end

    def self.find_by_user_id(user_id)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
            SELECT
                *
            FROM
                replies
            WHERE
                user_id = ?
        SQL
    end

    def self.find_by_question_id(question_id)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL
    end

    def self.find_by_parent_id(parent_reply_id)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, parent_reply_id)
            SELECT
                *
            FROM
                replies
            WHERE
                parent_reply_id = ?
        SQL
    end

    def author
        User.find_by_id(user_id)
    end

    def question
        Question.find_by_author_id(question_id)
    end

    def parent_reply
        Reply.find_by_id(parent_reply_id)
    end

    def child_replies
        Reply.find_by_parent_id(id)
    end

    
end