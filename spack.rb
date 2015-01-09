require 'zlib'

$add_zlib = true # Add require_zlib at last pack.

module SPack
	def self.pack_once(x)
		y = Zlib::Deflate.deflate(x,9)
		z = [y].pack('m')
		s = "s,p=\"#{z}\",\"ZXZhbChabGliOjpJbmZsYXRlLmluZmxhdGUocy51bnBhY2soJ20nKVswXSkp\";eval(p.unpack(\'m\').first)"
		#s = "s,p=#{z},eval(Zlib::Inflate.inflate(s.unpack('m')[0]))
		return s
	end
	def self.pack(x)
		fname = x
		t = rand(100)+30
		x = lambda{File.open(x,'rb'){|f|return f.read}}.call
		t.times{ x = SPack.pack_once(x) }
		if $add_zlib
			x= "require \'zlib\';#{x}"
		end
		File.open(fname+'_packed.rb','wb'){|f|f.write(x)}
	end
end

begin
	SPack.pack(ARGV[0])
end
