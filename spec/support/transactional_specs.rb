module TransactionalSpecs

  def self.included(base)
    base.class_eval do
      around(:each) do |spec|
        ActiveRecord::Base.transaction do
          begin
            spec.call
          ensure
            raise ActiveRecord::Rollback
          end
        end
      end
    end
  end

end
