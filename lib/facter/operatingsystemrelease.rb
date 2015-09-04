# Fact: osfamily
#
# Purpose: Returns the operating system
#
# Resolution:
#   if the operating system is Amazon, get the operating system release from /etc/system-release
# Caveats:
#   This fact is completely reliant on the operatingsystem fact, and no
#   heuristics are used
#

Facter.add(:operatingsystemrelease) do
  has_weight 100
  setcode do
    case Facter.value(:operatingsystem)
    when "Amazon"
        lines = File.open("/etc/system-release").to_a
        value = lines.first.split(" ")[-1]
    end
  end
end
