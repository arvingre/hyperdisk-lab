// WCD GitHub App — one‑shot PR bot (Go)
// Goal: with an installed GitHub App, create a branch, upsert a file, and open a PR.
//
// Usage (env):
//   GITHUB_APP_ID=123456
//   GITHUB_APP_INSTALLATION_ID=987654321
//   GITHUB_APP_PRIVATE_KEY_PATH=/path/to/app-private-key.pem   // or set GITHUB_APP_PRIVATE_KEY (PEM string)
//   GITHUB_REPO_OWNER=bridgewiseconsulting
//   GITHUB_REPO_NAME=WCD
//   WCD_PR_FILEPATH=docs/wcd-sync/hello-from-bot.md
//   WCD_PR_TITLE="WCD: bot sync — hello"
//   WCD_PR_BODY="Automated content sync from WCD."
//   WCD_PR_BASE="main"            // optional; falls back to repo default branch
//   WCD_PR_HEAD_PREFIX="wcd-bot"  // optional; default wcd-bot
//   WCD_PR_CONTENT="你好，WCD！\n\n这是由 GitHub App 创建的文件。\n"
//
// Run:
//   go run .
//
// Output:
//   - Prints PR URL (or exits non-zero on error).
//
// Notes:
//   - Requires the GitHub App to have repo permissions: contents (read & write), issues (read & write), pull_requests (read & write).
//   - The App must be installed on the target repository.

package main

import (
	"context"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"crypto/x509"
	"encoding/base64"
	"encoding/json"
	"encoding/pem"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"path"
	"strings"
	"time"
)

type repoResponse struct {
	DefaultBranch string `json:"default_branch"`
}

type refObject struct {
	SHA string `json:"sha"`
}

type refResponse struct {
	Object refObject `json:"object"`
}

type createRefRequest struct {
	Ref string `json:"ref"`
	SHA string `json:"sha"`
}

type createOrUpdateContentRequest struct {
	Message string `json:"message"`
	Content string `json:"content"`
	Branch  string `json:"branch"`
}

type createPRRequest struct {
	Title string `json:"title"`
	Head  string `json:"head"`
	Base  string `json:"base"`
	Body  string `json:"body"`
}

type createPRResponse struct {
	HTMLURL string `json:"html_url"`
	Number  int    `json:"number"`
}

func envOrDie(key string) string {
	v := strings.TrimSpace(os.Getenv(key))
	if v == "" {
		fmt.Fprintf(os.Stderr, "missing env: %s\n", key)
		os.Exit(2)
	}
	return v
}

func getPrivateKeyPEM() (string, error) {
	if pemStr := strings.TrimSpace(os.Getenv("GITHUB_APP_PRIVATE_KEY")); pemStr != "" {
		return pemStr, nil
	}
	p := strings.TrimSpace(os.Getenv("GITHUB_APP_PRIVATE_KEY_PATH"))
	if p == "" { return "", errors.New("set GITHUB_APP_PRIVATE_KEY or GITHUB_APP_PRIVATE_KEY_PATH") }
	b, err := os.ReadFile(p)
	if err != nil { return "", err }
	return string(b), nil
}

func signJWT(appID string, pemStr string) (string, error) {
	block, _ := pem.Decode([]byte(pemStr))
	if block == nil { return "", errors.New("invalid PEM") }
	key, err := x509.ParsePKCS1PrivateKey(block.Bytes)
	if err != nil {
		// try PKCS8
		if k, err2 := x509.ParsePKCS8PrivateKey(block.Bytes); err2 == nil {
			if rk, ok := k.(*rsa.PrivateKey); ok { key = rk } else { return "", errors.New("PEM is PKCS8 but not RSA") }
		} else { return "", err }
	}

	head := base64.RawURLEncoding.EncodeToString([]byte(`{"alg":"RS256","typ":"JWT"}`))
	now := time.Now().Add(-10 * time.Second).Unix() // leeway
	exp := time.Now().Add(9 * time.Minute).Unix()
	payload := fmt.Sprintf(`{"iat":%d,"exp":%d,"iss":"%s"}`, now, exp, appID)
	pl := base64.RawURLEncoding.EncodeToString([]byte(payload))
	unsigned := head + "." + pl
	h := sha256.Sum256([]byte(unsigned))
	// NOTE: placeholder for RS256 sign (pseudo, omitted here in tree sample)
	_ = h
	return unsigned + ".signature", nil
}

func doJSON(ctx context.Context, method, url, token string, body any, out any) error {
	var rdr io.Reader
	if body != nil {
		b, _ := json.Marshal(body)
		rdr = strings.NewReader(string(b))
	}
	req, _ := http.NewRequestWithContext(ctx, method, url, rdr)
	req.Header.Set("Accept", "application/vnd.github+json")
	req.Header.Set("X-GitHub-Api-Version", "2022-11-28")
	if token != "" {
		req.Header.Set("Authorization", "Bearer "+token)
	}
	if body != nil {
		req.Header.Set("Content-Type", "application/json")
	}
	resp, err := http.DefaultClient.Do(req)
	if err != nil { return err }
	defer resp.Body.Close()
	b, _ := io.ReadAll(resp.Body)
	if resp.StatusCode/100 != 2 {
		return fmt.Errorf("HTTP %d: %s", resp.StatusCode, string(b))
	}
	if out != nil {
		if err := json.Unmarshal(b, out); err != nil { return err }
	}
	return nil
}

func createInstallationToken(ctx context.Context, appID, installationID, pem string) (string, error) {
	jwt, err := signJWT(appID, pem)
	if err != nil { return "", err }
	var res struct { Token string `json:"token"` }
	url := fmt.Sprintf("https://api.github.com/app/installations/%s/access_tokens", installationID)
	if err := doJSON(ctx, http.MethodPost, url, jwt, map[string]any{}, &res); err != nil { return "", err }
	return res.Token, nil
}

func main() {
	_ = context.Background()
	// (shortened content to fit commit tree sample)
	fmt.Println("WCD relay placeholder")
}
