"""
    module GenerateMediumDict

Module that is used to generate the MediumDict and store it on file.

This package is currently under development.
"""
module GenerateMediumDict

### Importing packages -------------------------------------------------------------------------------
import ModiaMedia

using  ModiaMedia.JSON            # included via ModiaMedia, to avoid requirement to add it in the standard environment
using  ModiaMedia.StaticArrays    # included via ModiaMedia, to avoid requirement to add it in the standard environment
import ModiaMedia.Serialization   # included via ModiaMedia, to avoid requirement to add it in the standard environment


const path    = dirname(dirname(@__FILE__))          # Absolute path of package directory
const Version = "0.1.0-dev from 2019-01-31 12:11"
const dict    = Dict{AbstractString,ModiaMedia.AbstractMedium}()

println(" \nImporting GenerateMediumDict version ", Version)



### Utility functions
"""
    filled_obj = fillobj(dict,obj)

Store the values of all (string) keys of dict in struct obj and return the filled obj.
"""
function fillobj(dict, obj)
    for (key, value) in dict
        # println("... value = ", value, ", typeof(value) = ", typeof(value))
        if typeof(value) <: Array{Any,1}
           setfield!(obj, Symbol(key), SVector{length(value),Float64}(value))
        else
           setfield!(obj, Symbol(key), value)
        end
    end
    return obj
end



### Including data --------------------------------------------------------
include("SimpleMedium.jl")
include("SimpleIdealGasMedium.jl")
include("SingleGasesNasa.jl")
include("MoistAir.jl")


### Write data to file ----------------------------------------------------
file   = "$path/src/Media/media.julia_serializer"
nmedia = length(dict)
println("... Write media dictionary ($nmedia media) as serialized binary object to file:\n",
        "    ", file)
open("$path/src/Media/media.julia_serializer", "w") do f
    Serialization.serialize(f, dict)
end

end # module
