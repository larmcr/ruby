# Main

print "\n\t========== Menu Inicial ==========\n"
print "\t1. CLI (Command Line Interface)\n"
print "\t2. GUI (Graphical User Interface)\n"
print "\t==================================\n"
print "Opcion: "
option = gets().chomp
if(option == "1")
	load "CLI.rb"
elsif(option == "2")
	load "GUI.rb"
else
	print "Opcion no valida -> " + option + "\n";
end
