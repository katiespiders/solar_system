include Math

class SolarSystem

  def initialize(planets, age=4.568E9)
    @planets = planets
    @age = age.round
    @planets.each do |planet|
      planet.local_age = (@age / planet.orbital_rate)
    end
  end

  def to_s
    return "This solar system is #{sprintf("%.2e", @age)} arbitrary years old and contains #{@planets.length} planets.\n\n"
  end

  def display_for_user
    if @planets.length == 0
      abort "This isn't a solar system, it's just a star with no planets. Sorry I couldn't tell you anything cool."

    elsif @planets.length == 1
      puts "This solar system contains the planet #{@planets[0].name}."
      puts @planets[0]

    else
      intro = "This solar system contains the planets "
      name_string = list_to_text(get_name_list)
      puts intro + name_string + ". Which do you want to learn about?"
      while true
        get_planet_data
        puts "\nEnter another planet to see its data, or Q to quit."
      end
    end
  end

  def get_planet_data
    choice = gets.chomp.capitalize
    choice_index = get_name_list.index(choice)

    while not choice_index
      if choice == 'Quit' or choice == 'Q'
        abort "\nPeace out."
      else
        puts "\nPlanet #{choice} isn't in this solar system. Try again."
        choice = gets.chomp.capitalize
        choice_index = get_name_list.index(choice)
      end
    end

    planet = @planets[choice_index]
    puts planet # not precisely what was specified but I like this better...
    planet.generate_summary_table # not implemented
  end

  # this is very general and needs to go into a module, I'm going to use it again
  def list_to_text(list, separator=" and ")
    if list.length > 2
      i = 0
      text = ""

      (list.length - 1).times do
        text += list[i] + ", "
        i += 1
      end

      text += (separator.lstrip + list.last)
      return text
    elsif list.length == 2
      return list.join(separator)
    else
      return list[0]
    end
  end

  def get_name_list
    return @planets.collect { |planet| planet.name }
  end
end

class Planet
  attr_accessor :local_age, :orbital_rate # for SolarSystem's math
  attr_accessor :name, :type, :orbital_radius, :radius, :volume, :density, :mass, :moons # for SolarSystem's user interface

  def initialize(planet)
    @name = planet[:name]
    @type = planet[:type]
    @orbital_radius =  planet[:orbital_radius] # can i just give it its order from the sun and calculate from that? can i calculate this inside SolarSystem class? Pretty sure i can
    @orbital_rate = planet[:orbital_rate] # this should depend on orbital radius, not be hard-coded

    set_properties
  end

  def to_s
    big_number_display = "%.2e"
    regular_number_display = "%.2f"

# => figure out how to collect all instance variables as keys in a hash

#   data_strings =
    # {
    #   name_string: @name,
    #   type_string: @type.to_s.sub("_", " "),
    #   radius_string: sprintf(big_number_display, @radius),
    #   density_string: sprintf(regular_number_display, @density),
    #   mass_string: sprintf(big_number_display, @mass),
    #   local_age_string: sprintf(big_number_display, @local_age)
    # }

    type_string = @type.to_s.sub("_", " ")
    radius_string = sprintf(big_number_display, @radius)
    density_string = sprintf(regular_number_display, @density)
    mass_string = sprintf(big_number_display, @mass)
    local_age_string = sprintf(big_number_display, @local_age)

    return "\n#{@name} is a #{type_string} with radius #{radius_string} km and density #{density_string} g per cc, which works out to a mass of #{mass_string} kg. It has #{@moons} moons. It takes #{@orbital_rate} arbitrary years to make one revolution around the sun, making it #{local_age_string} #{@name}-years old.\n"
  end

  def generate_summary_table
  end

  def set_properties
    case @type
    when :dwarf_planet
      @radius = rand(2E3..1E4)
      @density = rand(2.0..3.0)
      @moons = rand(0..1)
    when :terrestrial_planet
      @radius = rand(2E4..1E5)
      @density = rand(3.0..6.0)
      @moons = rand(0..3)
    when :gas_giant
      @radius = rand (2E5..1E6)
      @density = rand(0.5..2.0)
      @moons = rand(25..75)
    end
    @radius = @radius
    @density = @density
    @mass = calc_mass
  end

  def calc_mass
    radius_cm = @radius * 1E6 # convert km to cm
    @volume = (4.0 * 3.0) * Math::PI * radius_cm**3 # in cubic cm
    @mass = @density * @volume # in g
    @mass = @mass / 1000 # in kg
  end
end

def main

  test_planets0 = []

  test_planets1 = [
    {
      name: "Arglebargle",
      type: :terrestrial_planet,
      orbital_radius: 5E4,
      orbital_rate: 0.25
    }]

  test_planets2 = [
    {
    name: "Arglebargle",
    type: :terrestrial_planet,
    orbital_radius: 5E4,
    orbital_rate: 0.25
  },

  {
    name: "Blergh",
    type: :terrestrial_planet,
    orbital_radius: 1.5E5,
    orbital_rate: 1.0
  }]

  test_planets = [
    {
      name: "Arglebargle",
      type: :terrestrial_planet,
      orbital_radius: 5E4,
      orbital_rate: 0.25
    },

    {
      name: "Blergh",
      type: :terrestrial_planet,
      orbital_radius: 1.5E5,
      orbital_rate: 1.0
    },

    {
      name: "Cletus",
      type: :gas_giant,
      orbital_radius: 5E5,
      orbital_rate: 2.0
    },

    {
      name: "Derp",
      type: :dwarf_planet,
      orbital_radius: 2.5E9,
      orbital_rate: 247.0
    }
  ]

  test_planets.collect! { |planet| Planet.new(planet) }

  s = SolarSystem.new(test_planets)
  puts s
  s.display_for_user

end

main
