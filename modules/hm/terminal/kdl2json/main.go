package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"os"

	"github.com/sblinch/kdl-go"
	"github.com/sblinch/kdl-go/document"
)

func main() {
	// Read KDL from stdin
	input, err := io.ReadAll(os.Stdin)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading input: %v\n", err)
		os.Exit(1)
	}

	// Parse KDL - kdl.Parse takes io.Reader
	doc, err := kdl.Parse(bytes.NewReader(input))
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error parsing KDL: %v\n", err)
		os.Exit(1)
	}

	// Convert to JSON-compatible structure
	jsonData := convertToJSON(doc)

	// Output as JSON
	encoder := json.NewEncoder(os.Stdout)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(jsonData); err != nil {
		fmt.Fprintf(os.Stderr, "Error encoding JSON: %v\n", err)
		os.Exit(1)
	}
}

// convertToJSON converts a KDL document to a JSON-compatible structure
func convertToJSON(doc *document.Document) interface{} {
	result := make([]interface{}, 0, len(doc.Nodes))
	for _, node := range doc.Nodes {
		result = append(result, nodeToJSON(node))
	}
	return result
}

// nodeToJSON converts a KDL node to a JSON-compatible map
func nodeToJSON(node *document.Node) map[string]interface{} {
	result := make(map[string]interface{})

	// Node name
	result["name"] = node.Name.String()

	// Arguments (positional values)
	if len(node.Arguments) > 0 {
		args := make([]interface{}, 0, len(node.Arguments))
		for _, arg := range node.Arguments {
			args = append(args, valueToJSON(arg))
		}
		result["args"] = args
	}

	// Properties (named key-value pairs)
	if len(node.Properties) > 0 {
		props := make(map[string]interface{})
		for key, value := range node.Properties {
			props[key] = valueToJSON(value)
		}
		result["props"] = props
	}

	// Children nodes
	if len(node.Children) > 0 {
		children := make([]interface{}, 0, len(node.Children))
		for _, child := range node.Children {
			children = append(children, nodeToJSON(child))
		}
		result["children"] = children
	}

	return result
}

// valueToJSON converts a KDL value to a JSON-compatible type
func valueToJSON(val *document.Value) interface{} {
	if val == nil {
		return nil
	}

	// Get the raw value from the Value struct
	v := val.Value

	switch v := v.(type) {
	case string:
		return v
	case int, int8, int16, int32, int64:
		return v
	case uint, uint8, uint16, uint32, uint64:
		return v
	case float32, float64:
		return v
	case bool:
		return v
	case nil:
		return nil
	default:
		// Fallback to string representation
		return fmt.Sprintf("%v", v)
	}
}
