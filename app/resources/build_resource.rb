class BuildResource < ApplicationResource
  attributes :git_sha, :git_url, :live, :live_at, :deployed_by, :notes

  belongs_to :group

  def deployed_by
    @model.public_key.name
  end

  def self.records(options={})
    if options[:context][:current_user].try(:staff?)
      options[:context][:group].builds
    end
  end
end
