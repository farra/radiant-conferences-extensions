class InitializeGlobalConfiguration < ActiveRecord::Migration
  def self.up

    presentation = PresentationType.new(:name => "Presentation")
    half_day = PresentationType.new(:name => "Training, Half-Day")
    full_day = PresentationType.new(:name => "Training, Full-Day")
    two_day  = PresentationType.new(:name => "Training, Two-Day")
    panel = PresentationType.new(:name => "Panel")
    keynote = PresentationType.new(:name => "Keynote")
    pbreak = PresentationType.new(:name => "Break")
    presentation.save; half_day.save; full_day.save; two_day.save;
    panel.save; keynote.save; pbreak.save;

    SponsorType.new(:name => "Sponsor").save
    SponsorType.new(:name => "Media Partner").save
    SponsorType.new(:name => "Community Partner").save
    SponsorType.new(:name => "Exhibitor").save

    SponsorLevel.new(:name => "Gold", :rank => 0).save
    SponsorLevel.new(:name => "Silver", :rank => 1).save
    SponsorLevel.new(:name => "Bronze", :rank => 2).save
    SponsorLevel.new(:name => "Special", :rank => 3).save
    SponsorLevel.new(:name => "Additional", :rank => 4).save

  end

  def self.down

  end
end
