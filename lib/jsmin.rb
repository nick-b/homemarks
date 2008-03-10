
class JsMin
  
  # jsmin.rb 2006-03-21
  # Author: Uladzislau Latynski
  # This work is a translation from C to Ruby of jsmin.c published by
  # Douglas Crockford.  Permission is hereby granted to use the Ruby
  # version under the same conditions as the jsmin.c on which it is
  # based.
  # 
  # Copyright (c) 2002 Douglas Crockford  (www.crockford.com)
  #
  # Permission is hereby granted, free of charge, to any person obtaining a copy of
  # this software and associated documentation files (the "Software"), to deal in
  # the Software without restriction, including without limitation the rights to
  # use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
  # of the Software, and to permit persons to whom the Software is furnished to do
  # so, subject to the following conditions:
  #
  # The above copyright notice and this permission notice shall be included in all
  # copies or substantial portions of the Software.
  # 
  # The Software shall be used for Good, not Evil.
  # 
  # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  # SOFTWARE.
  
  EOF = -1
  $theA = ""
  $theB = ""
  
  class << self
    
    def optimize(filename)
            
      @file = File.open(File.join(RAILS_ROOT, 'public', 'javascripts', filename))
      @newfile = File.open(File.join(File.dirname(@file.path), File.basename(@file.path).sub!('.js','_min.js')),'w')
      
      $theA = "\n"
      action(3)
      
      while ($theA != EOF)
        case $theA
        when " "
          if (isAlphanum($theB))
            action(1)
          else
            action(2)
          end
        when "\n"
          case ($theB)
          when "{","[","(","+","-"
            action(1)
          when " "
            action(3)
          else
            if (isAlphanum($theB))
              action(1)
            else
              action(2)
            end
          end
        else
          case ($theB)
          when " "
            if (isAlphanum($theA))
              action(1)
            else
              action(3)
            end
          when "\n"
            case ($theA)
            when "}","]",")","+","-","\"","\\"
              action(1)
            else
              if (isAlphanum($theA))
                action(1)
              else
                action(3)
              end
            end
          else
            action(1)
          end
        end
      end
      
      puts %Q|jsmin: Created new "#{File.basename(@newfile.path)}" in the public/javascripts directory.|
      @file.close
      @newfile.close
      
    end


    def action(a)

      if (a==1)
        @newfile.write $theA
      end
      
      if (a==1 || a==2)
        $theA = $theB
        if ($theA == "\'" || $theA == "\"")
          while (true)
            @newfile.write $theA
            $theA = get
            break if ($theA == $theB)
            raise "Unterminated string literal" if ($theA <= "\n")
            if ($theA == "\\")
              @newfile.write $theA
              $theA = get
            end
          end
        end
      end

      if (a==1 || a==2 || a==3)
        $theB = mynext
        if ($theB == "/" && ($theA == "(" || $theA == "," || $theA == "="))
          @newfile.write $theA
          @newfile.write $theB
          while (true)
            $theA = get
            if ($theA == "/")
              break
            elsif ($theA == "\\")
              @newfile.write $theA
              $theA = get
            elsif ($theA <= "\n")
              raise "Unterminated RegExp Literal"
            end
            @newfile.write $theA
          end
          $theB = mynext
        end
      end

    end


    def isAlphanum(c)
      return false if !c || c == EOF
      return ((c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || c == '_' || c == '$' || c == '\\' || c[0] > 126)
    end


    def get
      c = @file.getc
      return EOF if(!c)
      c = c.chr
      return c if (c >= " " || c == "\n" || c.unpack("c") == EOF)
      return "\n" if (c == "\r")
      return " "
    end


    def peek
      lookaheadChar = @file.getc
      @file.ungetc(lookaheadChar)
      return lookaheadChar.chr
    end


    def mynext
      c = get

      if (c == "/")
        if(peek == "/")
          while(true)
            c = get
            if (c <= "\n")
              return c
            end
          end
        end
        if (peek == "*")
          get
          while(true)
            case get
            when "*"
              if (peek == "/")
                get
                return " "
              end
            when EOF
              raise "Unterminated comment"
            end
          end
        end
      end

      return c
    end
    
    
  end
  
  
end

