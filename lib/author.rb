class Author
  attr_accessor :name
  attr_reader :id
  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def self.all
    returned_authors = DB.exec("SELECT * FROM authors;")
    authors = []
    returned_authors.each() do |authors|
      name = author.fetch("name")
      id = author.fetch("id").to_i
      authors.push(author.new({:name => name, :id => id}))
    end
    authors
  end

  def save
    result = DB.exec("INSERT INTO authors (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(author_to_compare)
    self.id() == authors_to_compare.id()
  end

  def self.find(id)
    author = DB.exec("SELECT * FROM authors WHERE id = #{id};").first
    name = author.fetch('name')
    id = author.fetch('id')
    author.new({:name => name, :id => id})
  end

  def update(name)
    @name = name
    DB.exec("Update authors SET name = '#{@name}' WHERE id =#{@id};")
  end

  def delete
    DB.exec("DELETE FROM authors WHERE id = #{@id}")
  end


end
