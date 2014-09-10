include Math


class SolarSystem


  def initialize(planets, age=rand(1.3e10))
    @planets = planets
    @age = age

    @planets.each do |planet|
      planet.local_age = (@age / planet.orbital_rate)
      planet.value_strings[:local_age] = sprintf("%.2e", planet.local_age)
    end
  end


  def to_s
    return "This solar system is #{sprintf("%.2e", @age)} arbitrary years old and contains #{@planets.length} #{if @planets.length == 1 then "planet" else "planets" end}. "
    # I could add a list of planets in order, numbered so the user can enter the number instead of typing the name
  end


  def display_for_user
    if @planets.length == 0
      abort "It's not actually a solar system though, it's just a star with no planets. Sorry to mislead you."

    elsif @planets.length == 1
      puts "Here's the data about it."
      puts @planets[0]

    else
      name_string = "They are " + list_to_text(get_name_list) + ". Which do you want to learn about?"
      puts name_string

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
        puts "\nThere's no planet #{choice} in this solar system. Try again."
        choice = gets.chomp.capitalize
        choice_index = get_name_list.index(choice)
      end
    end

    planet = @planets[choice_index]
    puts "\n"
    puts planet
    puts planet_distances(planet)
  end


  def planet_distances(planet)
    distance_string_list = []
    distance_text = "\n#{planet.name} is "

    @planets.each do |other_planet|

      if not other_planet == planet
        distance = planet.distance_to(other_planet)
        if distance < 0
          distance_string = "#{sprintf("%.2e", (-distance).to_s)} km closer to the sun than "
        elsif distance > 0
          distance_string = "#{sprintf("%.2e", (distance).to_s)} km farther from the sun than "
        else
          distance_string = "the same distance from the sun as"
        end

        distance_string += other_planet.name
        distance_string_list << distance_string
      end
    end

    return distance_text += list_to_text(distance_string_list) + "."
  end


  # this is very general and needs to go into a module (with an argument for oxford commas)
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
  attr_accessor :local_age, :orbital_rate, :name, :type, :orbital_radius, :radius, :volume, :density, :mass, :moons, :value_strings, :units


  def initialize(planet)
    @name = planet[:name]
    @type = planet[:type]
    @orbital_radius =  planet[:orbital_radius]
    @orbital_rate = planet[:orbital_rate]

    set_properties

    big_number_display = "%.2e"
    regular_number_display = "%.2f"

    @value_strings = {
      name: @name,
      type: @type.to_s.capitalize.sub("_", " "),
      orbital_radius: sprintf(big_number_display, @orbital_radius),
      orbital_rate: sprintf(regular_number_display, @orbital_rate),
      radius: sprintf(big_number_display, @radius),
      density: sprintf(regular_number_display, @density),
      moons: @moons.to_s,
      volume: sprintf(big_number_display, @volume),
      mass: sprintf(big_number_display, @mass)
    }

    @units = {
      orbital_radius: "km",
      orbital_rate: "arbitrary years",
      radius: "km",
      density: "g per cubic cm",
      moons: if @moons == 1 then "moon" else "moons" end,
      volume: "cubic km",
      mass: "kg",
      local_age: "arbitrary years"
    }
  end


  def to_s
    table = []

    variable_names = instance_variables.collect {|variable_name| variable_name.to_s[1..-1].to_sym } # to strip off the leading @ from the instance variable names and then convert them back to symbols to access the values and units arrays. Only about 75% clear on why I needed to do this
    variable_names.delete(:value_strings)
    variable_names.delete(:units)

    variable_names.each do |variable_name|
      row_title = variable_name.to_s.capitalize.sub("_", " ") + ": "
      row_value = @value_strings[variable_name]
      row_unit = @units[variable_name]
      row_unit = if row_unit then row_unit else "" end # to convert nil units to an empty string since nil can't be concatenated to a string

      row = row_title + row_value + " " + row_unit
      table << row
    end

    return table.join("\n")
  end


  # I didn't use this here but I don't want to delete it in case I want it for something else. I need to figure out about modules
  def get_column_widths
    string_keys = @value_strings.collect { |key, *| key.length }
    string_values = @value_strings.collect { |*, value| value.length }
    unit_values = @units.collect { |*, value| value.length }

    longest_string = string_keys.max + 2
    longest_value = string_values.max + 2
    longest_unit = unit_values.max + 2

    widths = {
      variable_column: longest_string,
      value_column: longest_value,
      unit_column: longest_unit
    }

    return widths
  end


  def set_properties
    case @type
    when :dwarf_planet
      @radius = rand(2E3..1E4)
      @density = rand(2.0..3.0)
      @moons = rand(0..1)
      @orbital_radius = rand(5E9..5E10)
    when :terrestrial_planet
      @radius = rand(2E4..1E5)
      @density = rand(3.0..6.0)
      @moons = rand(0..3)
      @orbital_radius = rand(5E7..5E8)
    when :gas_giant
      @radius = rand (2E5..1E6)
      @density = rand(0.5..2.0)
      @moons = rand(25..75)
      @orbital_radius = rand(1E9..5E9)
    end

    @radius = @radius
    @density = @density
    @orbital_rate = @orbital_radius / rand(1E7..1E8)
    @mass = calc_mass
  end


  def calc_mass
    radius_cm = @radius * 1E6 # convert km to cm
    @volume = (4.0 * 3.0) * Math::PI * radius_cm**3 # in cubic cm
    @mass = @density * @volume # in g
    @mass = @mass / 1000 # in kg
  end


  def distance_to(planet)
    return @orbital_radius - planet.orbital_radius
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

  test_planets3 = [
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
    }]

  planets = test_planets.collect! { |planet| Planet.new(planet) }

  s = SolarSystem.new(planets)
  puts s
  s.display_for_user
end

main
