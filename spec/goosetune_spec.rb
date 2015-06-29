require 'spec_helper'

describe Goosetune do
  it 'has a version number' do
    expect(Goosetune::VERSION).not_to be nil
  end

  describe Goosetune::Youtube do
    describe Goosetune::Youtube::Video do
      it 'is class Goosetune::Youtube::Video' do
        expect(described_class).to equal(Goosetune::Youtube::Video)
      end

      goosetune = Goosetune::Youtube::Video.new
      youtubes = goosetune.get_youtubes
      youtube = youtubes[youtubes.keys.first]

      it 'is Hash Goosetune::Youtube::Video#get_youtubes' do
	expect(youtube.class).to equal(Hash)
      end

      it 'have keys Goosetune::Youtube::Video#get_youtubes' do
        expect(youtube).to have_key(:id)
        expect(youtube).to have_key(:published)
        expect(youtube).to have_key(:title)
        expect(youtube).to have_key(:thumbnail)
        expect(youtube).to have_key(:original_artist)
        expect(youtube).to have_key(:original_title)
        expect(youtube).to have_key(:view_counts)
        expect(youtube).to have_key(:url)
      end

      it 'is Hash Goosetune::Youtube::Video#get_view_counts' do
        expect(goosetune.get_view_counts.class).to equal(Hash)
      end
    end

    describe Goosetune::Youtube::Channel do
      it 'is class Goosetune::Youtube::Channel' do
        expect(described_class).to equal(Goosetune::Youtube::Channel)
      end
    end
  end

  describe Goosetune::Ustream do
    describe Goosetune::Ustream::Video do
      it 'is class Goosetune::Ustream::Video' do
        expect(described_class).to equal(Goosetune::Ustream::Video)
      end

      goosetune = Goosetune::Ustream::Video.new
      ustreams = goosetune.get_ustreams
      ustream = ustreams[ustreams.keys.first]

      it 'is Hash Goosetune::Ustream::Video#get_ustreams' do
        expect(ustream.class).to equal(Hash)
      end

      it 'have keys Goosetune::Ustream::Video#get_ustreams' do
        expect(ustream).to have_key(:id)
        expect(ustream).to have_key(:title)
        expect(ustream).to have_key(:url)
        expect(ustream).to have_key(:thumbnail)
        expect(ustream).to have_key(:published)
        expect(ustream).to have_key(:view_counts)
      end

      it 'is Hash Goosetune::Ustream::Video#get_view_counts' do
	expect(goosetune.get_view_counts.class).to equal(Hash)
      end
    end
  end
end
