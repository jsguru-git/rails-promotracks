module Slackistrano
  class SlackistranoMessaging < Messaging::Base

    # Fancy updated message.
    # See https://api.slack.com/docs/message-attachments
    def payload_for_updated
      {
          attachments: [{
                            color: 'good',
                            title: 'Application Deployed :+1: :boom::bangbang:',
                            fields: [{
                                         title: 'Environment',
                                         value: stage,
                                         short: true
                                     }, {
                                         title: 'Branch',
                                         value: branch,
                                         short: true
                                     }, {
                                         title: 'Deployer',
                                         value: deployer,
                                         short: true
                                     }, {
                                         title: 'Time',
                                         value: elapsed_time,
                                         short: true
                                     }],
                            fallback: super[:text]
                        }]
      }
    end

    # Slightly tweaked failed message.
    # See https://api.slack.com/docs/message-formatting
    def payload_for_failed
      payload = super
      payload[:text] = "OMG :fire: #{payload[:text]}"
      payload
    end

    # Override the deployer helper to pull the full name from the password file.
    # See https://github.com/phallstrom/slackistrano/blob/master/lib/slackistrano/messaging/helpers.rb
    def deployer
      Etc.getpwnam(ENV['USER']).gecos
    end
  end
end