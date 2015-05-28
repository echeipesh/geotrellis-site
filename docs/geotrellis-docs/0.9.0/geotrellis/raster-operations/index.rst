.. _raster-operations-0.9.0:

Raster Operations
=================

Manipulation and processing of raster data is a large part of the GeoTrellis library. The approach taken to the organization of raster operations is in line with `C. Dana Tomlin’s Map Algebra`__, as detailed in the book GIS and Cartographic Modeling. Map Algebra breaks raster operations into three main categories:

__ http://www.amazon.com/GIS-Cartographic-Modeling-Dana-Tomlin/dp/158948309X

- :ref:`local-0.9.0`: Local operations calculate resulting raster cell values based on the value at the same cell location in one or more input rasters.
- :ref:`focal-0.9.0`: Focal operations calculate resulting raster cell values based on the values in a defined in a neighborhood around the same cell location in one or more input rasters.
- :ref:`zonal-0.9.0`: Zonal operations calcuate resulting raster cell values based on the values associated with that cell’s zone in one or more input rasters.

There are also some additional operation categories that GeoTrellis recognizes:

- :ref:`global-0.9.0`: Global operations are operations that need all information from the whole entire raster.
- :ref:`statistics-0.9.0`: Statistics operations compute statistics from raster values.

*Note:* For each Operation that takes an input Raster and returns a Raster, the data type of the output Raster will be the same as the input Raster, unless otherwise noted.

How operations are implemented
------------------------------

Raster operations are accessed through methods on the :ref:`RasterSource-0.9.0` type, or through methods on a sequence of :ref:`RasterSources <Operations on a Sequence of RasterSources-0.9.0>`.

Double vs Int
-------------

TODO

.. toctree::

   local
   focal
   global
   zonal
   statistics
   hydrology
