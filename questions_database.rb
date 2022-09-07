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

    def self.find_by_author_id(author_id)
        author = 
        QuestionsDatabase.instance.execute(<<-SQL, author_id)
        SELECT
            *
        FROM  
            questions
        WHERE
            author_id = ?
        SQL
        return nil unless question.length > 0
        author.each do |question|
            Questions.new(question)
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
end