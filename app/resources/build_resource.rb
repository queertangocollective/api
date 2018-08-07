class BuildResource < ApplicationResource
  attributes :git_sha, :git_url, :live, :live_at, :notes

  has_one :group
  has_one :deployed_by, class_name: 'Person', always_include_linkage_data: true

  def self.records(options={})
    if options[:context][:current_user].try(:staff?)
      options[:context][:group].builds
    end
  end
end
