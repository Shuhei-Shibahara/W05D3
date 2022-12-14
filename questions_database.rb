require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database   
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Users
    attr_accessor :id, :fname, :lname

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def self.find_by_id(id)
        user =
        QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM  
            users
        WHERE
            id = ?
        SQL
        return nil unless user.length > 0
        Users.new(user.first)
    end

    def self.find_by_name(fname, lname)
        user =
        QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
        SELECT
            *
        FROM  
            users
        WHERE
            fname = ? AND 
            lname = ?
        SQL
        return nil unless user.length > 0
        Users.new(user.first)
    end

    def authored_questions
        Questions.find_by_author_id(self.id)
    end

    def followed_questions
        QuestionFollows.followers_for_user_id(self.id)
    end
end


class Questions
    attr_accessor :id, :body, :user_id, :id

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end

    def self.find_by_id(id)
        question = 
        QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM  
            questions
        WHERE
            id = ?
        SQL
        return nil unless question.length > 0
        Questions.new(question.first)
    end

    def self.find_by_author_id(user_id)
        author = 
        QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT
            *
        FROM  
            questions
        WHERE
            user_id = ?
        SQL
        return nil unless author.length > 0
        author.map do |question|
            Questions.new(question)
        end
    
    end
end

class QuestionFollows
    attr_accessor :user_id, :question_id

    def initialize(options)
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

    def self.followers_for_questions_id(question_id)
        user = 
        QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT 
            fname, lname
        FROM 
            question_follows
        JOIN
            users ON users.id = question_follows.user_id
        WHERE
            question_id = ?
        SQL

        users.map do |user|
            QuestionFollows.new(user)
        end
    end

    def self.followers_for_user_id(user_id)
        users = 
        QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT 
            fname, lname, id
        FROM 
            question_follows
        JOIN
            users ON users.id = question_follows.user_id
        WHERE
            user_id = ?
        SQL

        users.map do |user|
            Users.new(user)
        end
    end

    def self.most_followed_question(n = 1)
        questions = 
        QuestionsDatabase.instance.execute(<<-SQL, n)
        SELECT
            question_id, user_id, COUNT(*) AS follows
        FROM
            question_follows
        GROUP BY
            question_id
        ORDER BY
            COUNT(*)
        LIMIT
            ?
        SQL
        questions.map do |question|
            QuestionFollows.new(question)
        end
    end
end 

class Replies
    attr_accessor :id, :question_id, :parent_reply, :author, :body

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply = options['parent_reply']
        @author = options['author']
        @body = options['body']
    end

    def self.find_by_id(id)
        reply = 
        QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM  
            replies
        WHERE
            id = ?
        SQL
        return nil unless reply.length > 0
        Replies.new(reply.first)
    end

    def parent_reply
        parent_reply = 
        QuestionsDatabase.instance.execute(<<-SQL, self.question_id)
        SELECT
            *
        FROM  
            replies
        WHERE
            question_id = ?
        ORDER BY
            id DESC
        LIMIT
            1
        OFFSET
            1
        SQL
        return nil unless parent_reply.length > 0
        Replies.new(parent_reply.first)
    end

end