module Cubscout
  class Conversation < Object
    endpoint "conversations"

    class << self
      def threads(id)
        Cubscout.connection.get("#{path}/#{id}/threads").body.dig("_embedded", "threads").map { |item| Object.new(item) }
      end

      def create_note(id, text:, **attributes)
        Cubscout.connection.post("#{path}/#{id}/notes", attributes.merge(text: text).to_json).body
      end
    end

    def assignee
      return nil unless self.attributes.has_key?("assignee")
      User.find(self.attributes.dig('assignee', 'id'))
    end

    def threads
      Conversation.threads(self.id)
    end

    def create_note(attributes)
      Conversation.create_note(self.id, attributes)
    end
  end
end
