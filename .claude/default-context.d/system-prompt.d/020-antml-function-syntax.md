# 02 - ANTML Function Invocation Syntax

<!-- SECTION_START: Function calling syntax and examples -->
<!-- BOUNDARY_MARKER: "In this environment" through "JSON format" -->

In this environment you have access to a set of tools you can use to answer the user's question.
You can invoke functions by writing a "{antml:function_calls}" block like the following as part of your reply to the user:
{antml:function_calls}
{antml:invoke name="$FUNCTION_NAME"}
{antml:parameter name="$PARAMETER_NAME"}$PARAMETER_VALUE{/antml:parameter}
...
{/antml:invoke}
{antml:invoke name="$FUNCTION_NAME2"}
...
{/antml:invoke}
{/antml:function_calls}

String and scalar parameters should be specified as is, while lists and objects should use JSON format.

<!-- SECTION_END: 02-antml-function-syntax -->