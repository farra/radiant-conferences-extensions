require 'yaml'

namespace :radiant do
  namespace :extensions do
    namespace :conferences do

      desc "Runs the migration of the Conferences extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          ConferencesExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          ConferencesExtension.migrator.migrate
        end
      end

      desc "Copies public assets of the Conferences to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[ConferencesExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(ConferencesExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end


      desc "migrate presenters"
      task :migrate_presenters => :environment do
        presenters = Presenter.find(:all)
        presenters.each do |presenter|
          presenter.presentation.presenter = presenter.person
          presenter.presentation.save
          presenter.save
        end
      end

      desc "import data"
      task :import => :environment do
        file = File.new('vendor/extensions/conferences/db/acus2008.yaml')
        conference = Conference.find_by_short_name("acus2008")
        YAML.each_document( file ) do | y |
          name = y["Submitted by"].match(/^([^\<]*)<([^\>]*)>.*/)[1].strip
          email = y["Submitted by"].match(/^([^\<]*)<([^\>]*)>.*/)[2].strip
          person = Person.find_by_email(email)
          unless person
            person = Person.new(:name => name, :email => email, :bio => y["Submitter bio"])
            person.save
          end
          presentation = Presentation.new
          presentation.name = y["Title"]
          presentation.description = y["Abstract"]
          presentation.duration = y["Duration"].split(" ")[0].to_i
          style = y["Style"]
          type = PresentationType.find_by_name(style)
          unless type
            type = PresentationType.new(:name => style)
            type.save
          end
          presentation.type = type
          presentation.presenter = person
          presentation.save

          presentation.tag_list.add( style )
          presentation.tag_list.add( y["Orientation"] )
          presentation.tag_list.add( y["Level"] )
          presentation.tag_list.add( y["Related project"] )
          presentation.tag_list.add( y["Categories"] )
          presentation.save

          submission = Submission.new
          submission.presentation = presentation
          submission.conference = conference
          submission.accepted = true
          submission.score = 0
          submission.votes = 0
          submission.comments = y["Submitter comments"]
          submission.save

        end
      end

    end
  end
end
