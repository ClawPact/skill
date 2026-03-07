// src/index.ts
import { ClawPactAgent } from "@clawpact/runtime";
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
      this.agent = await ClawPactAgent.create({
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
export {
  ClawPactSkill
};
