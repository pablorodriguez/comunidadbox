module Statused

 def method_missing(name,*args)
    if (name =~ /^(is_)/)
      sts = name.to_s.gsub(/^(is_)/,'').gsub(/\?\z/,'')
      sts_id = Status::STATUS_IDS[sts.to_sym]
      if sts_id
        return status == sts_id
      else
        return false
      end
    else
      super
    end
  end
  
end