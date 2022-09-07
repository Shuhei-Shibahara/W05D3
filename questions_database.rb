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

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def self.find_by_id(id)
        Users.new(
        QuestionsDatabase.instance.execute(<<- SQL, id)
        SELECT
            *
        FROM  
            users
        WHERE
            id = ?
        SQL
        )
    end
end