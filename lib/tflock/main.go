package main

import (
	"context"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"reflect"
	"strings"
	"time"

	"github.com/hashicorp/logutils"
	backendInit "github.com/hashicorp/terraform/internal/backend/init"
	"github.com/hashicorp/terraform/internal/command"
	"github.com/hashicorp/terraform/internal/command/clistate"
	"github.com/mitchellh/cli"
)

// Version is a version number.
var version = "1.6.4"

// LockCommand is a Command implementation that lock a Terraform state.
type LockCommand struct {
	command.StateMeta
}

// Run runs the procedure of this command.
func (c *LockCommand) Run(args []string) int {
	// Read the from state
	stateFromMgr, err := c.State()
	if err != nil {
		c.Ui.Error(fmt.Sprintf("Error loading the state: %s", err))
		return 1
	}

	stateLocker := clistate.NewLocker(context.Background(), (0 * time.Second), c.Ui, c.Colorize())
	if err := stateLocker.Lock(stateFromMgr, "tflock"); err != nil {
		c.Ui.Error(fmt.Sprintf("Error locking source state: %s", err))
		return 1
	}

	lockID := reflect.ValueOf(stateLocker).Elem().FieldByName("lockID")
	fmt.Println(lockID)

	return 0
}

// Help returns long-form help text.
func (*LockCommand) Help() string {
	helpText := `
Usage: tflock
`
	return strings.TrimSpace(helpText)
}

// Synopsis returns one-line help text.
func (c *LockCommand) Synopsis() string {
	return "Lock your Terraform state"
}

func logOutput() io.Writer {
	levels := []logutils.LogLevel{"TRACE", "DEBUG", "INFO", "WARN", "ERROR"}
	minLevel := os.Getenv("TFLOCK_LOG")

	// default log writer is null device.
	writer := ioutil.Discard
	if minLevel != "" {
		writer = os.Stderr
	}

	filter := &logutils.LevelFilter{
		Levels:   levels,
		MinLevel: logutils.LogLevel(minLevel),
		Writer:   writer,
	}

	return filter
}

func main() {
	log.SetOutput(logOutput())

	// Initialize the backends.
	// This is needed for registering backend types such as s3.
	backendInit.Init(nil)

	UI := &cli.BasicUi{
		Writer: os.Stdout,
		Reader: os.Stdin,
	}

	meta := command.Meta{
		Ui: UI,
	}

	commands := map[string]cli.CommandFactory{
		"": func() (cli.Command, error) {
			return &LockCommand{
				StateMeta: command.StateMeta{
					Meta: meta,
				},
			}, nil
		},
	}

	args := os.Args[1:]

	c := &cli.CLI{
		Name:       "tflock",
		Version:    version,
		Args:       args,
		Commands:   commands,
		HelpWriter: os.Stdout,
	}

	exitStatus, err := c.Run()
	if err != nil {
		UI.Error(fmt.Sprintf("Failed to execute CLI: %s", err))
	}

	os.Exit(exitStatus)
}
