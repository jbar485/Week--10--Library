require('spec_helper')

describe '#Book' do

  describe('.all') do
    it("returns an empty array when there are no books") do
      expect(Book.all).to(eq([]))
    end
  end

  describe('#save') do
    it("saves an book") do
      book = Book.new({:name => "Harry Potter", :id => nil, :return_date => "2017-07-23", :checkout_date => "2016-07-23"})
      book.save()
      book2 = Book.new({:name => "cool beans", :id => nil, :return_date => "2017-07-23", :checkout_date => "2016-07-23"})
      book2.save()
      expect(Book.all).to(eq([book, book2]))
    end
  end

  describe('#==') do
    it("is the same book if it has the same attributes as another book") do
      book = Book.new({:name => "cool beans", :id => nil, :return_date => "2017-07-23", :checkout_date => "2016-07-23"})
      book2 = Book.new({:name => "cool beans", :id => nil, :return_date => "2017-07-23", :checkout_date => "2016-07-23"})
      expect(book).to(eq(book2))
    end
  end

  describe('.find') do
    it("finds an book by id") do
      book = Book.new({:name => "Harry Potter", :id => nil, :return_date => "2017-07-23", :checkout_date => "2016-07-23"})
      book.save()
      book2 = Book.new({:name => "cool beans", :id => nil, :return_date => "2017-07-23", :checkout_date => "2016-07-23"})
      book2.save()
      expect(Book.find(book.id)).to(eq(book))
    end
  end

  describe('#update') do
    it("updates an book by id") do
      book = Book.new({:name => "Harry Potter", :id => nil, :return_date => "2017-07-23", :checkout_date => "2016-07-23"})
      book.save()
      book.update("A Love Supreme")
      expect(book.name).to(eq("A Love Supreme"))
    end
  end

  describe('#delete') do
    it("deletes an book by id") do
      book = Book.new({:name => "Harry Potter", :id => nil, :return_date => "2017-07-23", :checkout_date => "2016-07-23"})
      book.save()
      book2 = Book.new({:name => "cool beans", :id => nil, :return_date => "2017-07-23", :checkout_date => "2016-07-23"})
      book2.save()
      book.delete()
      expect(Book.all).to(eq([book2]))
    end
  end

  describe('#authors') do
    it("returns all authors that a book has") do
      author = Author.new({:name => "JK Rowling", :id => nil})
      author.save()
      book = Book.new({:name => "Harry Potter", :id => nil, :return_date => "2017-07-23", :checkout_date => "2016-07-23"})
      book.save()
      author2 = Author.new({:name => "ASD", :id => nil})
      author2.save()
      book.link_book_author(author.id)
      book.link_book_author(author2.id)
      expect(book.authors).to(eq([author, author2]))
    end
  end

  # describe('#songs') do
  #   it("returns an book's songs") do
  #     book = Book.new({:name => "Harry Potter", :id => nil, :return_date => "2017-07-23", :checkout_date => "2016-07-23"})
  #     book.save()
  #     song = Author.new({:name => "Naima", :book_id => book.id, :id => nil})
  #     song.save()
  #     song2 = Author.new({:name => "Cousin Mary", :book_id => book.id, :id => nil})
  #     song2.save()
  #     expect(book.songs).to(eq([song, song2]))
  #   end
  # end
end
