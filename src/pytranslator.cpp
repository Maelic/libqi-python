/*
**  Copyright (C) 2020 SoftBank Robotics Europe
**  See COPYING for the license
*/

#include <qipython/pytranslator.hpp>
#include <qipython/common.hpp>
#include <pybind11/pybind11.h>

namespace py = pybind11;

namespace qi
{
namespace py
{

void exportTranslator(::py::module& m)
{
  using namespace ::py;
  using namespace ::py::literals;

  gil_scoped_acquire lock;

  class_<Translator>(m, "Translator")
    .def(init([](const std::string& name) { return new Translator(name); }),
         call_guard<gil_scoped_release>(), "name"_a)
    .def("translate", &Translator::translate, call_guard<gil_scoped_release>(),
         "msg"_a, "domain"_a = "", "locale"_a = "", "context"_a = "",
         doc("Translate a message from a domain to a locale."))
    .def("translate", &Translator::translateContext,
         call_guard<gil_scoped_release>(), "msg"_a, "context"_a,
         doc("Translate a message with a context."))
    .def("setCurrentLocale", &Translator::setCurrentLocale,
         call_guard<gil_scoped_release>(), "locale"_a, doc("Set the locale."))
    .def("setDefaultDomain", &Translator::setDefaultDomain, "domain"_a,
         call_guard<gil_scoped_release>(), doc("Set the domain."))
    .def("addDomain", &Translator::addDomain, "domain"_a,
         doc("Add a new domain."));
}

} // namespace py
} // namespace qi
