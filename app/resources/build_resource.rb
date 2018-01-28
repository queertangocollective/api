class BuildResource < ApplicationResource
  attributes :git_sha, :git_url, :live, :live_at

  has_one :group
  has_one :public_key

  def self.records(options={})
    if options[:context][:current_user].try(:staff?)
      options[:context][:group].builds
    end
  end
end
