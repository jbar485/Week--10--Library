require('spec_helper')

describe '#patron' do

  describe('.all') do
    it("returns an empty array when there are no patrons") do
      expect(Patron.all).to(eq([]))
    end
  end

  describe('#save') do
    it("saves an patron") do
      patron = Patron.new({:id => nil, :password => "rats", :name => 'Woodkid'})
      patron.save()
      patron2 = Patron.new({:id => nil, :password => "rats", :name => 'Bjork'})
      patron2.save()
      expect(Patron.all).to(eq([patron, patron2]))
    end
  end

  describe('#==') do
    it("is the same patron if it has the same attributes as another patron") do
      patron = Patron.new({:name => "Blue", :password => "rats", :id => nil})
      patron2 = Patron.new({:name => "Blue", :password => "rats", :id => nil})
      expect(patron).to(eq(patron2))
    end
  end

  describe('.find') do
    it("finds an patron by id") do
      patron = Patron.new({:name => "A Love Supreme", :password => "rats", :id => nil})
      patron.save()
      patron2 = Patron.new({:name => "Blue", :password => "rats", :id => nil})
      patron2.save()
      expect(Patron.find(patron.id)).to(eq(patron))
    end
  end

  describe('#update') do
    it("updates an patron by id") do
      patron = Patron.new({:name => "A Love Supreme", :password => "rats", :id => nil})
      patron.save()
      patron.update("A Love Supreme", "rats")
      expect(patron.name).to(eq("A Love Supreme"))
    end
  end

  describe('#delete') do
    it("deletes an patron by id") do
      patron = Patron.new({:name => "A Love Supreme", :password => "rats", :id => nil})
      patron.save()
      patron2 = Patron.new({:name => "Blue", :password => "rats", :id => nil})
      patron2.save()
      patron.delete()
      expect(Patron.all).to(eq([patron2]))
    end
  end

  describe('#books') do
    it("returns all books that a patron has") do
      patron = Patron.new({:name => "A Love Supreme", :password => "rats", :id => nil})
      patron.save()
      book = Book.new({:name => "Harry Potter", :id => nil, :return_date => "2017-07-23", :checkout_date => "2016-07-23"})
      book.save()
      patron.link_patron_book(book.id)
      expect(patron.books).to(eq([book]))
    end
  end

  describe('#overdue_books') do
    it("returns all overdue books that a patron has") do
      patron = Patron.new({:name => "A Love Supreme", :password => "rats", :id => nil})
      patron.save()
      book = Book.new({:name => "Harry Potter", :id => nil, :return_date => "2015-07-23", :checkout_date => "2016-07-23"})
      book.save()
      patron.link_patron_book(book.id)
      expect(patron.overdue_books).to(eq([book]))
    end
  end

  describe('#is_checked_out') do
    it("returns true or false if book is checked out") do
      patron = Patron.new({:name => "A Love Supreme", :password => "rats", :id => nil})
      patron.save()
      book = Book.new({:name => "Harry Potter", :id => nil, :return_date => "2015-07-23", :checkout_date => "2016-07-23"})
      book.save()
      patron.link_patron_book(book.id)
      expect(patron.is_checked_out(book)).to(eq(true))
    end
  end



end
