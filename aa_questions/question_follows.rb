require_relative "questions_database"

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
end