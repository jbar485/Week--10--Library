require('spec_helper')

describe '#patron' do

  describe('.all') do
    it("returns an empty array when there are no patrons") do
      expect(Patron.all).to(eq([]))
    end
  end

  describe('#save') do
    it("saves an patron") do
      patron = Patron.new({:id => nil, :name => 'Woodkid'})
      patron.save()
      patron2 = Patron.new({:id => nil, :name => 'Bjork'})
      patron2.save()
      expect(Patron.all).to(eq([patron, patron2]))
    end
  end

  describe('.clear') do
    it("clears all patrons") do
      patron = Patron.new({:name => "A Love Supreme", :id => nil})
      patron.save()
      patron2 = Patron.new({:name => "Blue", :id => nil})
      patron2.save()
      Patron.clear
      expect(Patron.all).to(eq([]))
    end
  end

  describe('#==') do
    it("is the same patron if it has the same attributes as another patron") do
      patron = Patron.new({:name => "Blue", :id => nil})
      patron2 = Patron.new({:name => "Blue", :id => nil})
      expect(patron).to(eq(patron2))
    end
  end

  describe('.find') do
    it("finds an patron by id") do
      patron = Patron.new({:name => "A Love Supreme", :id => nil})
      patron.save()
      patron2 = Patron.new({:name => "Blue", :id => nil})
      patron2.save()
      expect(Patron.find(patron.id)).to(eq(patron))
    end
  end

  describe('#update_name') do
    it("updates an patron by id") do
      patron = Patron.new({:name => "A Love Supreme", :id => nil})
      patron.save()
      patron.update_name("A Love Supreme")
      expect(patron.name).to(eq("A Love Supreme"))
    end
  end

  describe('#delete') do
    it("deletes an patron by id") do
      patron = Patron.new({:name => "A Love Supreme", :id => nil})
      patron.save()
      patron2 = Patron.new({:name => "Blue", :id => nil})
      patron2.save()
      patron.delete()
      expect(Patron.all).to(eq([patron2]))
    end
  end

  describe('#update') do
    it("adds an album to an patron") do
      patron = Patron.new({:name => "John Coltrane", :id => nil})
      patron.save()
      patron.update({:album_name => "A Love Supreme"})
      expect(patron.albums).not_to(eq([]))
    end
  end

  describe('#update') do
    it("adds an album to an patron") do
      patron = Patron.new({:name => "John Coltrane", :id => nil})
      patron.save()
      patron.update({:album_name => "A Love Supreme"})
      expect(patron.albums).not_to(eq([]))
    end
  end


end
