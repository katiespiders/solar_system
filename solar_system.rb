include Math

class SolarSystem

  def initialize(planets, age=4.568E9)
    @planets = planets
    @age = age
    @planets.each do |planet|
      planet.local_age = @age * planet.orbital_rate
    end
  end

  def to_s
    solar_system_properties = "This solar system is #{@age} years old and contains #{@planets.length} planets.\n\n"
    property_array = @planets.collect {|planet| planet.to_s}
    planet_properties = "Planet properties:\n\n" + property_array.join("\n")
    return solar_system_properties + planet_properties
  end
end

class Planet
  attr_accessor :local_age, :orbital_rate

  def initialize(planet)
    @name = planet[:name]
    @type = planet[:type]
    @orbital_radius =  planet[:orbital_radius] # can i just give it its order from the sun and calculate from that? can i calculate this inside SolarSystem class?
    @orbital_rate = planet[:orbital_rate] # this should depend on orbital radius
    
    set_properties
  end

  def to_s
    return "#{@name} is a #{@type.to_s} with radius #{@radius} km and density #{@density} g per cc, which works out to a mass of #{@mass} kg. It has #{@moons} moons. It takes #{@orbital_rate} arbitrary years to make one revolution around the sun, making it #{@local_age} #{@name}-years old.\n"
  end

  def set_properties
    # return random radius depending on planet type
    case @type
    when :planetoid
      @radius = rand(2E3..1E4)
      @density = rand(2.0..3.0)
      @moons = rand(0..1)
    when :terrestrial
      @radius = rand(2E4..1E5)
      @density = rand(3.0..6.0)
      @moons = rand(0..3)
    when :gas_giant
      @radius = rand (2E5..1E6)
      @density = rand(0.5..2.0)
      @moons = rand(25..75)
    end
    @radius = @radius.round
    @density = @density.round(2)
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
  test_planets = [
    {
      name: "Arglebargle",
      type: :terrestrial,
      orbital_radius: 5E4,
      orbital_rate: 0.25
    },

    {
      name: "Blergh",
      type: :terrestrial,
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
      type: :planetoid,
      orbital_radius: 2.5E9,
      orbital_rate: 247.0
    }
  ]

  test_planets.collect! { |planet| Planet.new(planet) }

  s = SolarSystem.new(test_planets)
  puts s

end

main
