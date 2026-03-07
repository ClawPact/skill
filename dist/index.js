"use strict";
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __export = (target, all) => {
  for (var name in all)
    __defProp(target, name, { get: all[name], enumerable: true });
};
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);

// src/index.ts
var index_exports = {};
__export(index_exports, {
  ClawPactSkill: () => ClawPactSkill
});
module.exports = __toCommonJS(index_exports);
var import_runtime = require("@clawpact/runtime");
var ClawPactSkill = class {
  agent = null;
  config;
  constructor(config) {
    this.config = config;
  }
  /**
   * Initialize the ClawPact agent using the provided UI configuration
   */
  async initialize() {
    if (!this.agent) {
      this.agent = await import_runtime.ClawPactAgent.create({
        privateKey: this.config.AGENT_PK,
        // Replace with real SIWE/JWT fetching logic if required
        jwtToken: "placeholder-jwt-token"
      });
      await this.agent.start();
    }
    return this.agent;
  }
  /**
   * Action: Get Available Tasks
   */
  async getAvailableTasks(params = {}) {
    const agent = await this.initialize();
    return await agent.getAvailableTasks({ status: "OPEN", limit: params.limit || 10 });
  }
  /**
   * Action: Bid on a task
   */
  async bidOnTask(params) {
    const agent = await this.initialize();
    return await agent.bidOnTask(params.taskId, params.proposal);
  }
  /**
   * Action: Confirm Task
   */
  async confirmTask(params) {
    const agent = await this.initialize();
    return await agent.client.confirmTask(BigInt(params.escrowId));
  }
  /**
   * Action: Submit Delivery
   */
  async submitDelivery(params) {
    const agent = await this.initialize();
    return await agent.client.submitDelivery(BigInt(params.escrowId), params.deliveryHash);
  }
  /**
   * Action: Publish Showcase
   */
  async publishShowcase(params) {
    const agent = await this.initialize();
    return await agent.social.publishShowcase({
      channel: params.channel || "showcase",
      title: params.title,
      content: params.content,
      tags: params.tags,
      relatedTaskId: params.relatedTaskId
    });
  }
  /**
   * Action: Query Knowledge Mesh
   */
  async queryKnowledge(params) {
    const agent = await this.initialize();
    return await agent.knowledge.query({ domain: params.domain });
  }
};
// Annotate the CommonJS export names for ESM import in node:
0 && (module.exports = {
  ClawPactSkill
});
