class ValidateAddress
  @@DOMAIN_REGEXP1 = /^[0-9a-zA-Z!#$%&'*+\-\/=?^_`{|}~.]{1,}$/
  @@DOMAIN_REGEXP2 = /^\..*/
  @@DOMAIN_REGEXP3 = /.*?\.$/
  @@DOMAIN_REGEXP4 = /.*?\.\..*/

  @@QUOTED_REGEXP1 = /^"[0-9a-zA-Z!#$%&'*+\-\/=?^_`{|}~(),.:;<>@\[\]"\\]*"$/
  @@QUOTED_REGEXP2 = /[\\"]/
  def validate(address)
    atmark_splitted_address = address.split '@'
    domain = atmark_splitted_address.pop
    local = atmark_splitted_address.join '@'
    if (local_check local) && (domain_check domain)
      'ok'
    else
      'ng'
    end
  end

  def domain_check(domain)
    @@DOMAIN_REGEXP1.match(domain) != nil && @@DOMAIN_REGEXP2.match(domain) == nil && @@DOMAIN_REGEXP3.match(domain) == nil && @@DOMAIN_REGEXP4.match(domain) == nil
  end

  def local_check(local)
    if @@QUOTED_REGEXP1.match(local)
      quoted_check local
    else
      domain_check local
    end
  end

  def quoted_check(quoted)
    unquoted = quoted.slice(1, quoted.length - 2).gsub('\\\\', '').gsub('\\"', '')
    @@QUOTED_REGEXP2.match(unquoted) == nil
  end
end