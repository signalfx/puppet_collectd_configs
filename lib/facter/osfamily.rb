# Fact: osfamily
#
# Purpose: Returns the operating system of Amazon linux as 'Redhat'
# Resolution:
#   if the operating system is Amazon, report the osfamily as 'Redhat'
# Caveats:
#   This fact is completely reliant on the operatingsystem fact, and no
#   heuristics are used
#

Facter.add(:osfamily) do
  has_weight 100
  setcode do
    case Facter.value(:operatingsystem)
    when "Amazon"
      "RedHat"
    end
  end
end
