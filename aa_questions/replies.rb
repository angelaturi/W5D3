require_relative "questions_database"

class Reply 
    attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

    def self.all
        data = QuestionsDBConnection.instance.execute('SELECT * FROM replies')
        data.map {|datum| Reply.new(datum)}
    end

    def self.find_by_id(id)
        user_data = QuestionsDBConnection.instance.execute(<<-SQL, @id)
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
end