# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

module Syndi
  module Talk

    # A mixin which provides a class with the essential methods to make it able
    # to be communicated across a Syndi::Talk connection.
    module Object

      # This method serializes the class into JSON data. It calls the `to_talk`
      # method if it is defined and injects that data into the JSON hash under
      # the `data` key.
      def to_json *a
        data = { json_class: self.class.name, id: self.object_id }
        data[:data] = to_talk if respond_to? :to_talk
        data.to_json *a
      end

    end

  end
end


# vim: set ts=4 sts=2 sw=2 et:
