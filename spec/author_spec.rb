describe '#Author' do

  describe('#==') do
    it("is the same author if it has the same attributes as another author") do
      author = Author.new({:name => "JK Rowling", :id => nil})
      author.save
      author2 = Author.new({:name => "JK Rowling", :id => nil})
      author2.save
      expect(author).to(eq(author2))
    end
  end

  describe('.all') do
    it("returns a list of all authors") do
      author = Author.new({:name => "JK Rowling", :id => nil})
      author.save()
      author2 = Author.new({:name => "hot rod", :id => nil})
      author2.save()
      expect(Author.all).to(eq([author, author2]))
    end
  end


  describe('#save') do
    it("saves a author") do
      author = Author.new({:name => "hot rod", :id => nil})
      author.save()
      expect(Author.all).to(eq([author]))
    end
  end

  describe('.find') do
    it("finds a author by id") do
      author = Author.new({:name => "JK Rowling", :id => nil})
      author.save()
      author2 = Author.new({:name => "hot rod", :id => nil})
      author2.save()
      expect(Author.find(author.id)).to(eq(author))
    end
  end

  describe('#update') do
    it("updates an author by id") do
      author = Author.new({:name => "hot rod", :id => nil})
      author.save()
      author.update("Mr. P.C.")
      expect(author.name).to(eq("Mr. P.C."))
    end
  end

  describe('#delete') do
    it("deletes an author by id") do
      author = Author.new({:name => "JK Rowling", :id => nil})
      author.save()
      author2 = Author.new({:name => "hot rod", :id => nil})
      author2.save()
      author.delete()
      expect(Author.all).to(eq([author2]))
    end
  end


  # describe('.find_by_book') do
  #   it("finds authors for an book") do
  #     book2 = Book.new({:name => "Harry Potter", :id => nil, :return_date => "2017-07-23", :checkout_date => "2016-07-23"})
  #     book2.save
  #     author = Author.new({:name => "JK Rowling", :id => nil})
  #     author.save()
  #     expect(Author.find_by_book(book2.id)).to(eq([author]))
  #   end
  # end
  #
  describe('#books') do
    it("returns all books that a author has") do
      author = Author.new({:name => "JK Rowling", :id => nil})
      author.save()
      book = Book.new({:name => "Harry Potter", :id => nil, :return_date => "2017-07-23", :checkout_date => "2016-07-23"})
      book.save()
      book2 = Book.new({:name => "hot rod", :id => nil, :return_date => "2017-07-23", :checkout_date => "2016-07-23"})
      book2.save()
      book.link_book_author(author.id)
      book2.link_book_author(author.id)
      expect(author.books).to(eq([book, book2]))
    end
  end
end
